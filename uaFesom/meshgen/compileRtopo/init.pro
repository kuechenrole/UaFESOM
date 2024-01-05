pro init
window, colors=100 & wdelete
if !d.n_colors gt 256 then device,  decomposed = 0 $
ELSE device, pseudo_color=8
end

