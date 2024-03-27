import { expect } from "chai"
import hre from "hardhat"
import { config } from "dotenv"
import { MyToken } from "@/typechain-types"
config()
describe("ICO", function () {
  let MyToken: MyToken
  this.beforeAll(async () => {
    MyToken = await hre.ethers.deployContract("MyToken", ["ArashToken", "ATK"])
  })

  it("should deploy smart contract", async function () {
    const ICO = await hre.ethers.deployContract("ICO", [
      MyToken,
      process.env.CONTRACT_OWNER,
    ])
    expect(
      +hre.ethers.formatEther(
        await MyToken.balanceOf(process.env.CONTRACT_OWNER),
      ),
    ).to.equal(100_000_000)

    await ICO.activate(60_000)
    console.log("qwe2")

    console.log("qwe3")
    const amount = await ICO.airDropAmount()
    await MyToken.approve(ICO, BigInt(1e20))
    const allowance = await MyToken.allowance(process.env.CONTRACT_OWNER, ICO)
    console.log(allowance, "Allowance")
    const s = await MyToken.balanceOf(process.env.CONTRACT_OWNER)
    console.log(s, "BalanceOF<<")

    await MyToken.transfer(ICO, BigInt(1e20))

    const ICO_balance = await ICO.balanceOfEth(ICO)
    console.log(ICO_balance, "<<<<<<<")

    console.log("qwe4")
    await ICO.airDrop(process.env.CONTRACT_OWNER)
    console.log("AirDropped")

    const airDropAmount = await ICO.airdrops(process.env.CONTRACT_OWNER)
    console.log(airDropAmount)

    expect(hre.ethers.formatEther(airDropAmount)).to.be.equal(
      hre.ethers.formatEther(amount),
    )
  })
})
