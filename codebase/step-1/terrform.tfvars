# tfvars

user_node_size           = "Standard_D4s_v5"
user_node_disk_size_gb   = 128
user_node_min_count      = 1
user_node_max_count      = 3
user_node_count          = 1

# --------------------------
# Spot Node Pool
# --------------------------
spot_node_size           = "Standard_D4s_v5"
spot_node_disk_size_gb   = 128
spot_node_min_count      = 0
spot_node_max_count      = 5
spot_node_count          = 1