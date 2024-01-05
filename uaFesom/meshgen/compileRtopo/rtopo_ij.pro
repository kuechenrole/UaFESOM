function rtopo_ij,index

; This function converts the 1d index to ij=(i,j).
; Ralph Timmermann 19.08.2013

ijarr=lonarr(n_elements(index),2)

anzxrg=21601
anzyrg=10801

;help,ij

ijarr(*,0) = index mod anzxrg
ijarr(*,1) = index/anzxrg

return,ijarr
end

