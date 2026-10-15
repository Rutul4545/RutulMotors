$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$toolRoot = Join-Path $env:USERPROFILE 'Tools\RutulMotors'
$javaHome = Join-Path $toolRoot 'jdk-17'
$mavenHome = Join-Path $toolRoot 'apache-maven-3.9.16'
$tomcatHome = Join-Path $toolRoot 'apache-tomcat-9.0.123'
$mysqlBase = 'C:\Program Files\MySQL\MySQL Server 8.0'
$mysqlData = Join-Path $toolRoot 'mysql-data'
$mysqlExe = Join-Path $mysqlBase 'bin\mysqld.exe'

foreach ($path in @(
        (Join-Path $javaHome 'bin\java.exe'),
        (Join-Path $mavenHome 'bin\mvn.cmd'),
        (Join-Path $tomcatHome 'bin\catalina.bat'),
        $mysqlExe,
        (Join-Path $env:USERPROFILE '.rutulmotors-db.properties')
    )) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required local setup file is missing: $path"
    }
}

$env:JAVA_HOME = $javaHome
$env:MAVEN_HOME = $mavenHome
$env:CATALINA_HOME = $tomcatHome
$env:Path = "$javaHome\bin;$mavenHome\bin;$env:Path"

function Test-LocalPort([int] $port) {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $client.Connect('127.0.0.1', $port)
        return $true
    } catch {
        return $false
    } finally {
        $client.Dispose()
    }
}

if (-not (Test-LocalPort 3307)) {
    $mysqlArguments = "--no-defaults --basedir=`"$mysqlBase`" --datadir=`"$mysqlData`" --port=3307 --bind-address=127.0.0.1 --mysqlx=0 --log-error=`"$mysqlData\mysql.err`""
    Start-Process -FilePath $mysqlExe -ArgumentList $mysqlArguments -WindowStyle Hidden | Out-Null
    $databaseReady = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if (Test-LocalPort 3307) {
            $databaseReady = $true
            break
        }
        Start-Sleep -Seconds 1
    }
    if (-not $databaseReady) {
        throw "The Rutul Motors database did not start. Check $mysqlData\mysql.err."
    }
}

if (Test-LocalPort 8080) {
    throw 'Port 8080 is already in use. Stop the other web server before starting Rutul Motors.'
}

& (Join-Path $mavenHome 'bin\mvn.cmd') -f (Join-Path $projectRoot 'pom.xml') package -DskipTests
if ($LASTEXITCODE -ne 0) {
    throw "The Rutul Motors WAR build failed (exit $LASTEXITCODE)."
}

$war = Join-Path $projectRoot 'target\RutulMotors.war'
$deployment = Join-Path $tomcatHome 'webapps\RutulMotors.war'
Copy-Item -LiteralPath $war -Destination $deployment -Force

Write-Output 'Rutul Motors is starting. Open http://localhost:8080/RutulMotors/AdminSetupServlet to create the first admin account.'
& (Join-Path $tomcatHome 'bin\catalina.bat') run
if ($LASTEXITCODE -ne 0) {
    throw "Tomcat stopped with exit code $LASTEXITCODE."
}
