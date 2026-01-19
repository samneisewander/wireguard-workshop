WIREGUARD_DIR=wireguard
PRESENTER_DIR=presenter-materials
LISTENPORT=51820

# Generate public/private key pair for wireguard "hub"
server_priv_key=$(wg genkey)
server_pub_key=$(echo ${server_priv_key} | wg pubkey)

mkdir -p $WIREGUARD_DIR
mkdir -p $PRESENTER_DIR

# Generate interface portion of the hub's wg0.conf.
cat <<EOF > $WIREGUARD_DIR/wg0.conf
[Interface]
Address = 10.8.0.0/24
PrivateKey = ${server_priv_key}
ListenPort = ${LISTENPORT}

EOF

# Generate 30 public/private key pairs for the "spokes" (i.e. the peers to the central wireguard server running in the docker 
# container.
# The idea here is that attendees can be given one of these key pairs so that they can configure their laptop as a peer to the
# server running the container as an exercise.
# A list of private keys and public keys can be found in their respective files. IP addresses are assigned following a logical 
# convention where the ith key corresponds to the ip 10.8.0.i
truncate -s 0 $PRESENTER_DIR/private_keys
truncate -s 0 $PRESENTER_DIR/public_keys
for i in {1..30}; do 
    pubkey=$(wg genkey | tee -a $PRESENTER_DIR/private_keys | wg pubkey | tee -a $PRESENTER_DIR/public_keys)
    cat <<EOF >> $WIREGUARD_DIR/wg0.conf
[Peer]
PublicKey = ${pubkey}
AllowedIPs = 10.8.0.${i}/32    

EOF
done

# Generate an example wireguard client configuration.
cat <<EOF > $PRESENTER_DIR/example.wg0.conf
[Interface]
Address = 10.8.0.1/24
PrivateKey = $(head -n 1 $PRESENTER_DIR/private_keys)

[Peer]
PublicKey = ${server_pub_key}
Endpoint = 127.0.0.1:${LISTENPORT} # REPLACE WITH SERVER ADDRESS
AllowedIPs = 10.8.0.0/24
EOF

