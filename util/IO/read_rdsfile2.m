function [d, kspace, navall, gnav, ao, pnavall] = read_rdsfile2(pfile, kacqfile)
% function [kspace,nav,gnav,ao] = read_rdsfile(pfile, kacqfile)
% 
% This is a function to load rds data.
%
% Input: 
%   pfile    -- pfile name.
%   kacqfile -- kacq file name.
%
% Output: 
%   kspace -- ks ordered by ao
%   nav    -- all navigators ordered by ao
%   gnav   -- gradients of butterfly navigator
%   ao     -- ao(:,1): y-order, ao(:,2): z-order, ao(:,3): phase-order
%
% Note: modified from Tao Zhang's rawloadRDS (2012/09/27). 
%
% (c) Joseph Y Cheng (jycheng@mrsrl.stanford.edu) 2012

    DBPRINT = 1;
    
    if DBPRINT
        dbdisp('reading raw header...');
    end
    [h,hs] = read_gehdr(pfile);
    nPreNav = h.rdb.user8;
    nNav = h.rdb.user9;
    nRead = h.rdb.user10;
    necho = h.rdb.nechoes;
    rhdayres = h.rdb.da_yres;
    frsize = h.rdb.frame_size;clc
    ncoils = 1 + h.rdb.dab_stop_rcv(1) - h.rdb.dab_start_rcv(1);
    nslices = h.rdb.nslices;
    dtype = sprintf('int%d', h.rdb.point_size*8);
    
    if DBPRINT
        dbdisp('reading kacq file...');
    end
    [ao,gnav] = read_kacq(kacqfile);
    np = max(ao(:,3));
    npe = size(ao,1);
    
    if DBPRINT
        dbdisp('reading raw data...');
    end
    fip = fopen(pfile,'r','l');
    if fip == -1
        error(sprintf('File %s not found\n',pfile));
    end
    fseek(fip, hs, -1);    
    d = single(fread(fip, inf, dtype));
    fclose(fip);
    d = reshape(d,[2 length(d)/2]);
    d = d(1,:) + 1i*d(2,:);
    
    yres = rhdayres;
    nz = length(d)/frsize/ncoils/yres/np;
    
    %% removing base-line
    d = reshape(d,[frsize,yres,nz*ncoils*np]);
    d = d(:,2:end,:);
    d = reshape(d,[frsize,yres-1,necho,nz,ncoils,np/necho]);%%?
    % d(:,:,2,:,2:end,:) = flip(d(:,:,2,:,2:end,:),1);
    d = permute(d,[1 2 4 5 3 6]);
    d = reshape(d,[frsize,yres-1,nz,ncoils,np]);
    if DBPRINT
        dbdisp('extracting data from raw...');
    end    
    %% re-format
    d = reshape(d,[frsize,(yres-1)*nz,ncoils,np]);

    kspace = single(zeros(nRead,npe,ncoils));
    pnavall = single(zeros(nPreNav,npe,ncoils));
    navall = single(zeros(nNav,npe,ncoils));
    offset = 0;
    for N=1:np
        npei = sum(ao(:,3)==(N));
        kspace(:,(1:npei)+offset,:) = d(end-nRead+1:end,1:npei,:,N);
        pnavall(:,(1:npei)+offset,:) = d(1:nPreNav,1:npei,:,N);
        navall(:,(1:npei)+offset,:) = d(nPreNav+(1:nNav),1:npei,:,N);
        offset = offset + npei;
    end