import React, {useContext, useEffect, useState} from "react";
import {ERC20Context, UniswapV2Router02Context, CurrentAddressContext} from "../hardhat/SymfoniContext";
import {ERC20} from "../hardhat/typechain/ERC20";
import ethers from "ethers";

interface Props { tokenA: string; tokenB: string;}

export const Swap: React.FC<Props> = ({ tokenA, tokenB }) => {
    //
    // Retrieving Token Symbols
    //
    const ERC20Factory = useContext(ERC20Context);

    const [tokenAInstance, setTokenAInstance] = useState<ERC20>();
    const [tokenBInstance, setTokenBInstance] = useState<ERC20>();

    const [tokenASymbol, setTokenASymbol] = useState<string>();
    const [tokenBSymbol, setTokenBSymbol] = useState<string>();

    useEffect(() => {
        if (ERC20Factory.instance) {
            setTokenAInstance(ERC20Factory.instance!.attach(tokenA));
            setTokenBInstance(ERC20Factory.instance!.attach(tokenB));
        }
    }, [ERC20Factory.instance, tokenA, tokenB]);

    useEffect(() => {
        const fetchTokenSymbols = async () => {
            if (!tokenAInstance || !tokenBInstance) { return; }

            setTokenASymbol(await tokenAInstance.symbol());
            setTokenBSymbol(await tokenBInstance.symbol());
        };
        fetchTokenSymbols();
    }, [tokenBInstance, tokenAInstance])

    //
    // Field for entering swap amount
    //
    const [amount, setAmount] = useState<number>(0);

    const handleAmountChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        setAmount(parseInt(event.target.value));
    };

    //
    // Displaying the tokens exchanged value
    //
    const router = useContext(UniswapV2Router02Context);
    //console.log(router.instance.address);
    const [exchangeAmount, setExchangeAmount] = useState<string>("0");

    useEffect(() => {
        const fetchExchangeAmount = async () => {
            if (!router.instance) {
                console.log("router instance not found");
                return;
            }

            if (amount > 0) {
                // router gets angry if you pass in a 0
                console.log("Router Address", router.instance.address);
                console.log("tokenA", tokenA)
                console.log("tokenB", tokenB)
                const amountsOut = await router.instance.getAmountsOut(
                    ethers.utils.parseEther(amount.toString()),
                    [tokenA, tokenB]
                );
                setExchangeAmount(ethers.utils.formatUnits(amountsOut[1].toString(), 18));
            }
        };

        fetchExchangeAmount();
    }, [router.instance, amount, tokenA, tokenB]);

    //
    // Executing swap
    //
    const [currentAddress, setCurrentAddress] = useContext(CurrentAddressContext);

    const handleSwap = async () => {
        if (!router.instance || !tokenAInstance) {
            console.log("router or token instance not found");
            return;
        }
        const time = Math.floor(Date.now() / 1000) + 3600;

        await (await tokenAInstance.approve(router.instance.address, ethers.utils.parseEther(amount.toString()))).wait();
        await (await router.instance.swapExactTokensForTokens(
            ethers.utils.parseEther(amount.toString()),
            0, // we shouldn't leave this as 0, it is dangerous in real trading
            [tokenA, tokenB],
            currentAddress,
            time
        )).wait();
    };

    return (
        <div className="bg-white shadow sm:rounded-lg">
            <div className="px-4 py-5">
                <div className="grid grid-cols-3 gap-4">
                    <div className="text-gray-800 text-4xl">{tokenASymbol}</div>
                    <div className="text-gray-800 text-3xl"> to </div>
                    <div className="text-gray-800 text-4xl">{tokenBSymbol}</div>
                    <div className="flex justify-center">
                        <span className="flex-item text-gray-800 text-2xl">Amount:</span>
                        <input
                            type="text"
                            name="Amount"
                            id="amount"
                            className="mx-2 flex-item shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block  border-gray-300 rounded-md text-gray-800 text-2xl w-1/6 text-center"
                            placeholder="5"
                            onChange={handleAmountChange}
                        />
                    </div>
                    <div></div>
                    <div className="flex justify-center">
                        <span className="flex-item text-gray-800 text-2xl">Receive:</span>
                        <input
                            type="text"
                            name="Receive"
                            id="receive"
                            disabled
                            className="mx-2 flex-item shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block  border-gray-300 rounded-md text-gray-800 text-2xl w-1/6 text-center"
                            placeholder="5"
                            value={exchangeAmount}
                        />
                    </div>
                    <div></div>
                    <div></div>
                    <button
                        type="submit"
                        className="mt-3 inline-flex items-center justify-center px-4 py-2 border border-transparent shadow-sm font-medium rounded-md text-white bg-gray-800 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                        onClick={handleSwap}
                    >
                        Swap!
                    </button>
                </div>
            </div>
        </div>
    );
};