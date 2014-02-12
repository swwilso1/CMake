set(ref "@var@")
set(right "wrong")
set(var "\${right}")

string(CONFIGURE "${ref}" output)
message("-->${output}<--")
