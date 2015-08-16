Add-PSSnapin "Microsoft.SharePoint.Powershell"
$STSName = "Embedded STS"

Remove-SPTrustedIdentityTokenIssuer $STSName

#certifcate to verify the signed authentication token
$certpath = "EmbeddedSTS.cer"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($certpath)

$map1 = New-SPClaimTypeMapping "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress" -IncomingClaimTypeDisplayName "EmailAddress" -SameAsIncoming 
$map2 = New-SPClaimTypeMapping "http://schemas.microsoft.com/ws/2008/06/identity/claims/role" -IncomingClaimTypeDisplayName "Role" -SameAsIncoming
$map3 = New-SPClaimTypeMapping "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/privatepersonalidentifier" -IncomingClaimTypeDisplayName "Private Personal Identifier" -SameAsIncoming
$map4 = New-SPClaimTypeMapping "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant" -IncomingClaimTypeDisplayName "Authentication Instant" -SameAsIncoming
$map5 = New-SPClaimTypeMapping "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod" -IncomingClaimTypeDisplayName "Authentication Method" -SameAsIncoming

#realm
$realm = "https://<Insert your own url>/_trust/"

# URL where the Embedded STS is running
$signinurl = "http://localhost:29072/_sts/"

#Register the identity provider. Please not  that the Wreply parameter has been set: With ADFS this is not needed, but EmbeddedSTS otherwise returns a default value, which won't work with SharePoint
New-SPTrustedIdentityTokenIssuer -Name Embedded STS -Description "Embedded STS" -Realm $realm -ImportTrustCertificate $cert -ClaimsMappings $map1, $map2, $map3, $map4, $map5 -SignInUrl $signinurl -IdentifierClaim $map1.InputClaimType -UseWReply $true
