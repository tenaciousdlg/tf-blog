output "ghost" {
  value = <<EOF
  This was run from ${chomp(data.http.myip.body)}

  Your droplet can be reached at ${digitalocean_droplet.web.ipv4_address}

  SSH Command: 
    ssh -i ${var.do_key_path} root@${digitalocean_droplet.web.ipv4_address}

  Cloud Init logs on Droplet:
    less /var/log/cloud-init-output.log
  EOF
}