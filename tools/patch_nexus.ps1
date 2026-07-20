# patch_nexus.ps1 - Unlock A5 engine NEXUS beyond the 40 MB default.
#
# Applied to every 565248-byte module exe in the game folder:
#   1) .data default nexus MB: 40 -> 512  (file offset 0x7BE54)
#   2) Disable INI/app-name path that could overwrite nexus with ~20-30
#      (change jz -> jmp at file offset 61310)
#   3) Set PE LARGEADDRESSAWARE so VirtualAlloc(512MB) can succeed in 32-bit
#
# The cracked script/self-checksum patches are left untouched.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$NEXUS_OFF = 0x7BE54
$JZ_OFF = 61310
$NEW_NX = 512

$patched = 0
Get-ChildItem -File *.exe | Where-Object { $_.Length -eq 565248 } | ForEach-Object {
  $b = [IO.File]::ReadAllBytes($_.FullName)
  [BitConverter]::GetBytes([int32]$NEW_NX).CopyTo($b, $NEXUS_OFF)
  if ($b[$JZ_OFF] -ne 0x74 -and $b[$JZ_OFF] -ne 0xEB) {
    throw "$($_.Name): unexpected opcode at override site"
  }
  $b[$JZ_OFF] = 0xEB
  $lf = [BitConverter]::ToInt32($b, 0x3C)
  $dllOff = $lf + 24 + 0x46
  $dll = [BitConverter]::ToUInt16($b, $dllOff) -bor 0x20
  $b[$dllOff] = $dll -band 0xFF
  $b[$dllOff + 1] = ($dll -shr 8) -band 0xFF
  [IO.File]::WriteAllBytes($_.FullName, $b)
  $patched++
}
Write-Host "Nexus unlock applied to $patched module executables (default ${NEW_NX} MB + LAA)."
