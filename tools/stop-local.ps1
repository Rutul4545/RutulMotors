$ErrorActionPreference = 'Stop'

$toolRoot = Join-Path $env:USERPROFILE 'Tools\RutulMotors'
$tomcatHome = Join-Path $toolRoot 'apache-tomcat-9.0.123'
$mysqlHome = 'C:\Program Files\MySQL\MySQL Server 8.0'
$adminConfig = Join-Path $toolRoot 'mysql-admin.cnf'

if (Test-Path -LiteralPath (Join-Path $tomcatHome 'bin\catalina.bat')) {
    & (Join-Path $tomcatHome 'bin\catalina.bat') stop
}

$client = New-Object System.Net.Sockets.TcpClient
try {
    $client.Connect('127.0.0.1', 3307)
    $client.Close()
    $mysqlAdmin = Join-Path $mysqlHome 'bin\mysqladmin.exe'
    & $mysqlAdmin "--defaults-extra-file=$adminConfig" --protocol=TCP --host=127.0.0.1 --port=3307 shutdown
    if ($LASTEXITCODE -ne 0) {
        throw "Could not stop the isolated Rutul Motors database (exit $LASTEXITCODE)."
    }
} catch [System.Net.Sockets.SocketException] {
    Write-Output 'Rutul Motors database is not running.'
} finally {
    $client.Dispose()
}
