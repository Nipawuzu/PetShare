set PORTS=7290 4301 7060

(for %%a in (%PORTS%) do ( 
    adb reverse tcp:%%a tcp:%%a
))