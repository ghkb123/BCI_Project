import React from "react";
import "./App.css";
import { Symfoni } from "./hardhat/SymfoniContext";
import { Swap } from "./components/Swap";

function App() {
  return (
    <div className="App">
      <Symfoni autoInit={true}>
        <div className="min-h-screen bg-gray-800">
          <div className="max-w-7xl mx-auto sm:px-6 lg:px-8 ">
            <div className="text-gray-100 text-6xl pt-28 pb-10">
              Swappity Swap
            </div>
            <Swap
              tokenA="0x0662340314cFc736aC18A0c71b950BF2c35e8D9C"
              tokenB="0x1a598cA3602f0BC8f284a6B1b6c8397779246f7A"
            ></Swap>
          </div>
        </div>
      </Symfoni>
    </div>
  );
}

export default App;