terraform { 
  backend "remote" { 
    
    organization = "BankiFi" 

    workspaces { 
      name = "tf-wsp-baseline-ukwest" 
    } 
  } 
}
