string=("java.awt.AWTPermission"
"java.io.FilePermission"
"java.io.SerializablePermission"
"java.lang.management.ManagementPermission"
"java.lang.ReflectiPermission"
"java.lang.RuntimePermission"
"java.net.NetPermission"
"java.net.SocketPermission"
"java.net.URLPermission"
"java.nio.file.LinkPermission"
"java.security.unresolvedPermission"
"java.sql.SQLPermission"
"java.util.logging.LoggingPermission"
"java.util.PropertyPermission"
"javax.management.MBeanPermission"
"javax.management.MBeanServerPermission"
"javax.management.MBeanTrustPermission"
"javax.management.remote.SubjectDelegationPermission"
"javax.net.ssl.SSLPermission"
"javax.security.auth.AuthPermission"
"javax.security.auth.kerberos.ServicePermission"
"javax.security.auth.PrivateCredentialPermission"
"javax.sound.sample.ArudioPermission"
"javax.xml.bind.JAXBPermission"
"javax.xml.ws.WebServicePermission")

for frase in ${string[@]}; do
    echo "<permission class=\"${frase}\" name=\"*\" actions=\"read,write\" />"
done

# <permission class="java.util.*" name="*" actions="read,write" />
