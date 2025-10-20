terraform { 
  backend "remote" { 
    
    organization = "BankiFi" 

    workspaces { 
      name = "tf-wsp-baseline-ukwest" 
    } 
  } 
}

# terraform { 
#   cloud { 
    
#     organization = "BankiFi" 

#     workspaces { 
#       name = "tf-wsp-baseline-ukwest" 
#     } 
#   } 
# }


# terraform {
#   backend "remote" {
#     organization = "BankiFi"
#     workspaces {
#       name = "tf-wsp-baseline"
#     }
#   }
# }