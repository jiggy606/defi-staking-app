const Tether = artifacts.require("Tether");
const RWD = artifacts.require("RWD");
const DecentralBank = artifacts.require("DecentralBank");

require('chai')
.use(require('chai-as-promised'))
.should

contract('DecentralBank', ([owner, customer]) => {
    let tether, rwd, decentralBank

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    before(async () => {
        // LOad contracts
        tether = await Tether.new()
        rwd = await RWD.new()
        decentralBank = await DecentralBank.new(rwd.address, tether.address)

        //Transfer 1M to DecentralBank
        await rwd.transfer(decentralBank.address, tokens('1000000'))

        //Transfer 100 to customer
        await tether.transfer(customer, tokens('100'), {from: owner})
    })

   /*  describe('Mock Tether Deployment', async () => {
        it('correct name matches', async () => {
            let tether = await Tether.new()
            const name = await tether.name()
            assert.equal(name, 'Tether Token')
        })
    }) */

    /* describe('RWD Deployment', async () => {
        it('correct name matches', async () => {
            const name = await rwd.name()
            assert.equal(name, 'Reward Token')
        })
    }) */

    describe('Decentral Bank Deployment', async () => {
        it('correct name matches', async () => {
            const name = await decentralBank.name()
            assert.equal(name, 'Decentral Bank')
        })

        it('there are tokens', async () => {
            balance = await rwd.balanceOf(decentralBank.address)
            assert.equal(balance, tokens('1000000'))
        })

        describe('Yield Farming', async () => {
            it('reward tokens for staking', async () => {
                let result

                // check the balance of the investor
                result = await tether.balanceOf(customer)
                assert.equal(result.toString(), tokens('100'), 'wallet balance of customer before staking')
            

                await tether.approve(decentralBank.address, tokens('10'), {from: customer})
                await decentralBank.depositTokens( tokens('10'), { from: customer })

                result = await tether.balanceOf(decentralBank.address)
                assert.equal(result.toString(), tokens('10'), 'wallet balance of customer after staking')
                console.log("reult2", result.toString())

                result = await decentralBank.stakingBalance(customer)
                assert.equal(result.toString(), tokens('0'), 'decentral bank of customer after staking from customer')
                console.log("reult3", result.toString())

                result = await decentralBank.isStaked(customer)
                assert.equal(result.toString(), 'true', 'customer status to be true')
                console.log("reult4", result.toString())

                // issue token
                await decentralBank.issueTokens({ from: owner });
                
                // only owner can issue token
                await decentralBank.issueTokens({from: customer}).should.be.rejected;
                 }) 
    })
    })


}) 