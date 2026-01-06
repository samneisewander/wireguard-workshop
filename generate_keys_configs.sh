# Generate public/private key pair for wireguard "hub"
mkdir -p keys
cd keys
target_priv=$(wg genkey | tee target)
target_pub=$(echo ${target_priv} | wg pubkey | tee target.pub)

# Generate interface portion of the hub's wg0.conf.
cat <<EOF > wg0.conf
[Interface]
Address = 192.168.1.0/24
PrivateKey = ${target_priv}
ListenPort = 8080

EOF

# Generate 30 public/private key pairs for the "spokes" (i.e. the peers to the central wireguard server running in the docker container.
# The idea here is that attendees can be given one of these key pairs so that they can configure their laptop as a peer to the server running the container as an exercise.
# A list of private keys and public keys can be found in their respective files. IP addresses are assigned following a logical convention where the ith key corresponds to the ip 192.168.1.i
truncate -s 0 private_keys
for i in {1..30}; do 
    pubkey=$(wg genkey | tee -a private_keys | wg pubkey | tee -a public_keys)
    cat <<EOF >> wg0.conf
[Peer]
PublicKey = ${pubkey}
AllowedIPs = 192.168.1.${i}/32    

EOF
    
done

