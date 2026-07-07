# Install winget packages (winget must be available, Win10 1809+)
winget install --id=Git.Git -e
winget install --id=Microsoft.VisualStudioCode -e  # (optional)
winget install --id=Neovim.Neovim -e
winget install --id=Oracle.JDK.17 -e
winget install --id=OpenJS.NodeJS.LTS -e
winget install --id=Python.Python.3.12 -e
winget install --id=Docker.DockerDesktop -e
winget install --id=MongoDB.Shell -e
winget install --id=MongoDB.Compass.Full -e   # optional GUI
winget install --id=PostgreSQL.PostgreSQL -e
winget install --id=MySQL.MySQL -e
winget install --id=VideoLAN.VLC -e
winget install --id=Mozilla.Firefox -e
winget install --id=TablePlus.TablePlus -e
winget install --id=Bruno.Bruno -e
winget install --id=FreeFileSync.FreeFileSync -e
winget install --id=Cisco.PacketTracer -e    # may need manual download

# Notepad alternative: Notepad++ (or use built-in notepad)
winget install --id=Notepad++.Notepad++ -e

# Quick Share: Microsoft's built-in Nearby Sharing or Snapdrop (web app)
Write-Host "Quick Share: Use Windows Nearby Sharing or open https://snapdrop.net"

# Sysinfo
systeminfo | Select-Object -First 20
