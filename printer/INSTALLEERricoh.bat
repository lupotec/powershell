set pat=%cd%\
set scriptFileName=script.ps1

powershell -Command "Start-Process powershell \"-ExecutionPolicy Bypass -NoProfile -NoExit -Command `\"cd \`\"%pat%`\"; & \`\".\%scriptFileName%\`\"`\"\" -Verb RunAs"
