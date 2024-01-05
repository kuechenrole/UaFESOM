function countwherelems,array

countpoints=n_elements(array)
if countpoints eq 1 then begin
 if array eq -1 then begin
  countpoints=0
 endif
endif

return,countpoints
end
