// test/test_fundme.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FundMe", function () {
  let FundMe, fundMe, owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    FundMe = await ethers.getContractFactory("FundMe");
    fundMe = await FundMe.deploy();
    await fundMe.deployed();
  });

  it("Should allow funding and update the amount funded", async function () {
    await fundMe.connect(addr1).fund({ value: ethers.utils.parseEther("1") });
    expect(await fundMe.addressToAmountFunded(addr1.address)).to.equal(ethers.utils.parseEther("1"));
  });

  it("Should allow the owner to withdraw funds", async function () {
    await fundMe.connect(addr1).fund({ value: ethers.utils.parseEther("1") });
    await expect(() => fundMe.connect(owner).withdraw()).to.changeEtherBalances([fundMe, owner], [ethers.utils.parseEther("-1"), ethers.utils.parseEther("1")]);
  });

  it("Should not allow non-owner to withdraw funds", async function () {
    await fundMe.connect(addr1).fund({ value: ethers.utils.parseEther("1") });
    await expect(fundMe.connect(addr1).withdraw()).to.be.revertedWith("NotOwner");
  });

  it("Should pause and unpause the contract", async function () {
    await fundMe.connect(owner).pause();
    await expect(fundMe.connect(addr1).fund({ value: ethers.utils.parseEther("1") })).to.be.revertedWith("Contract is paused");
    
    await fundMe.connect(owner).unpause();
    await fundMe.connect(addr1).fund({ value: ethers.utils.parseEther("1") });
    expect(await fundMe.addressToAmountFunded(addr1.address)).to.equal(ethers.utils.parseEther("1"));
  });
});
