r410_vms = {
  vm1 = { name = "k8s-control-plane1.server" },
  vm2 = { name = "k8s-control-plane2.server" },
  vm3 = { name = "k8s-control-plane3.server" }
}

ibm_vms = {
  vm1 = { name = "k8s-node1.server", target_node = "ibm-x3200-prox1", clone_template = 212 },
  vm2 = { name = "k8s-node2.server", target_node = "ibm-x3200-prox1", clone_template = 212 },
  vm3 = { name = "k8s-node3.server", target_node = "ibm-x3200-prox2", clone_template = 313 }
}
