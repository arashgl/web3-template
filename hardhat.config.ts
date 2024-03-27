import { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"
import "hardhat-watcher"
import "@nomicfoundation/hardhat-foundry"

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  defaultNetwork: "hardhat",
  watcher: {
    compilation: {
      tasks: ["compile"],
      files: ["./contracts"],
      ignoredFiles: [
        "**/.vscode",
        "**/.git",
        "**/.gitignore",
        "**/.DS_Store",
        "**/.idea",
      ],
      verbose: true,
      clearOnStart: true,
      start: "echo Running my compilation task now..",
    },
    ci: {
      tasks: [
        "clean",
        { command: "compile", params: { quiet: true } },
        {
          command: "test",
          params: { noCompile: true, testFiles: ["./test/Lock.ts"] },
        },
      ],
    },
  },
  networks: {
    // localganache: {
    //   url: "http://127.0.0.1:7545",
    //   accounts: [
    //     `0x7736cdab9cc707bf09df30f096c2ac876c0288b813b79b60fe41f8982a659c28`,
    //   ],
    // },
    // hardhat: {
    //   forking: {
    //     url: "http://127.0.0.1:7545",
    //   },
    // },
    // hardhat: {
    //   forking: {
    //     url: "https://polygon-mumbai.infura.io/v3/eab9100fee6a4d8abfe05660a6da1c03",
    //   },
    // },
    // hardhat: {
    //   accounts: [
    //     {
    //       privateKey:
    //         "0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba",
    //       balance: "1000000000000000000000",
    //     },
    //   ],
    //   chainId: 31337,
    // },
  },
}

export default config
