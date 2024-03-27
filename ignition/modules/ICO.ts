import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"
import dotenv from "dotenv"
dotenv.config()

const _owner = process.env.CONTRACT_OWNER
const ONE_GWEI: bigint = 1_000_000_000n

const ICOModule = buildModule("ICOModule", (m) => {
  const token = m.contract("MyToken", ["ArashToken", "ATK"])
  console.log(token, "THIS IS TOKEN OBJ<<<<<<<<")
  const ico = m.contract("ICO", [token, _owner])
  return { token, ico }
})

export default ICOModule
