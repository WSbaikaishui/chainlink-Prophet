### Prophet

Prophet can earn.(now we build on mumbai,using chainlink functions,so you can use test gas to test it)



#### Proposition

Forecast whether the propositions will be TRUE or FALSE. You earn if your forelook is judged correct. Each proposition has an ID and a due time. **Forelook everything before it goes due!**

| Propostion:                                               | ID   | due time             |
| --------------------------------------------------------- | ---- | -------------------- |
| Will Donald Trump win the 2024 U.S. president nomination? | 28   | Dec.31 2023 23:59:59 |

#### Chainlink
![image](https://github.com/WSbaikaishui/chainlink-Prophet/assets/46080358/56a20dbe-451f-4abd-8d68-7b19355fdc67)

Our project is built on the Chainlink ecosystem. This project is running on Polygon Mumbai Testnet. In Prophet, we use USDT and Yes / No as test tokens. Each transaction can be viewed through Polygon explorer. Chainlink Oracle will also be used for the data predictions.

**Price-Feed**

For price prediction proposals, Prophet adopts the **Price-Feed** of Chainlink, which can make the prices we extract provide fair enough.

**Function**

For proposals that will obtain results from external links, Prophet uses the **Function** of Chainlink. This function enables the contract to easily access external APIs. Since the APIs were already on chain when the proposal is launched, the links cannot be modified. Coupled with the access to multiple nodes of **Function**, the results we obtain are accurate enough.

**Automation**

**Automation** function of Chainlink allows the contract to trigger the judge by itself under specific conditions. This largely saves labor costs and ensures that the judge is carried out in a timely manner, consolidating the entire project.

#### deposit

Give me 100 USD, and I will give you 100 TRUE and 100 FALSE tokens of a certain proposition. You still need to [buy/sell](#buysell) between TRUE and FALSE tokens to bet for a certain position. 

| USD              | TRUE | FALSE |
| ---------------- | ---- | ----- |
| 100              | 0    | 0     |
| deposit(100 USD) |      |       |
| 0                | 100  | 100   |

#### redeem

**Before a proposition goes due**, give me 100 TRUE and 100 FALSE tokens of the same proposition, and I will give 100 USD back to you. 

| USD             | TRUE | FALSE |
| --------------- | ---- | ----- |
| 0               | 150  | 120   |
| redeem(100 USD) |      |       |
| 100             | 50   | 20    |

#### buy/sell

Give me TRUE tokens, and I will give you FALSE tokens, and vice versa. Sell all of your FALSE tokens for TRUE tokens to bet for 100% TRUE. 

The price is defined by an [automated market maker](https://flamingo-1.gitbook.io/user-guide/v/master/flamingo-litepaper#convert) (AMM), constrained by xy=k. For example, when the liquidity pool has TRUE/FALSE = 1200/900, you can give me 100 FALSE tokens to get approximately 1200-(1200*900/(900+100)) = 120 TRUE tokens. The resulting liquidity in the pool will be changed to TRUE/FALSE = (1200-120)/(900+100) = 1080/1000.

A small amount of fee (0.6%) is accrued from your input token, to pay grand gratitudes for the contributors of the liquidity pool. We can never forelook, if there were no liquidity providers. 

| USD  | TRUE | FALSE                                       |
| ---- | ---- | ------------------------------------------- |
| 0    | 150  | 120                                         |
|      |      | sell(100 FALSE; pool TRUE/FALSE = 1200/900) |
| 0    | 270  | 20                                          |

#### add/removeLiquidity

**Before a proposition goes due**, charge TRUE and FALSE tokens as liquidity into the AMM pool to help people [buy/sell](#buysell) TRUE and FALSE tokens smoothly, suffering less slippage. You earn the fees paid by buyers. 

The TRUE/FALSE proportion charged and removed is always the same of that in the pool. 

| USD                             | TRUE                       | FALSE | YOUR LIQUIDITY   |
| ------------------------------- | -------------------------- | ----- | ---------------- |
| 0                               | 150                        | 120   | 0                |
| addLiquidity(120 TRUE/90 FALSE) | pool TRUE/FALSE = 1200/900 |       |                  |
| 0                               | 30                         | 30    | [A LARGE AMOUNT] |

#### winnerRedeem

If a proposition is judged FALSE, you can give me 100 FALSE tokens for 100 USD! Do not forget to keep your TRUE tokens as souvenir, and forelook what merits they will bring in the future!

| USD                     | TRUE                | FALSE |
| ----------------------- | ------------------- | ----- |
| 0                       | 150                 | 120   |
| winnerRedeem(120 FALSE) |                     |       |
| 120 (YOUR INCOME)       | 150 (YOUR SOUVENIR) | 0     |
