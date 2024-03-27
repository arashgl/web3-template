import { ExternalProvider } from "@ethersproject/providers"

declare global {
  interface Window {
    ethereum?: ExternalProvider
  }

  namespace NodeJS {
    interface ProcessEnv {
      NEXT_PUBLIC_CONTRACT_ADDRESS: string
      CONTRACT_OWNER: string
    }
  }
}
