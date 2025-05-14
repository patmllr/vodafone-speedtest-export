import subprocess
import sys
import os

try:
    vbs_path = os.path.join(sys._MEIPASS, "launcher_run.vbs") if hasattr(sys, "_MEIPASS") else "launcher_run.vbs"

    # Logging für Debug
    with open("launcher-debug.log", "w") as f:
        f.write("launcher_run.vbs path: " + vbs_path + "\n")
    
    # Testweise sichtbar aufrufen
    result = subprocess.run(["wscript", vbs_path], capture_output=True, text=True)
    
    with open("launcher-debug.log", "a") as f:
        f.write("Returncode: " + str(result.returncode) + "\n")
        f.write("STDOUT:\n" + result.stdout + "\n")
        f.write("STDERR:\n" + result.stderr + "\n")

except Exception as e:
    import traceback
    with open("launcher-error.log", "w") as f:
        f.write(traceback.format_exc())