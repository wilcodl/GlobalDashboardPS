function Set-InsecureSSL {
    <#
    .SYNOPSIS
        Allow invalid SSL
    .DESCRIPTION
        Set CertificatePolicy to TrustAllCertsPolicy and SecurityProtocol to Ssl3,Tls,Tls11,Tls12
    .NOTES
       Only supported on Windows PowerShell
    .EXAMPLE
        Set-InsecureSSL
    #>
    
    [cmdletbinding(SupportsShouldProcess)]
    param()

    if (-not ("TrustAllCertsPolicy" -as [type])) {

Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    }

    if($PSCmdlet.ShouldProcess("ShouldProcess?")){
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    }
    # else {
    # }

}