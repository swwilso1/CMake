set(right "wrong")
set(var "\${right}")
set(ref "@var@")

string(CONFIGURE "${ref}" output)
message("-->${output}<--")
