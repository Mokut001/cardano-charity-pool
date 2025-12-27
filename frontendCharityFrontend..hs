{-# LANGUAGE OverloadedStrings #-}

module CharityFrontend where

import Lucid
import Data.Text (Text)

scriptAddress :: Text
scriptAddress = "addr_test1wqxyzplaceholderforcontract..." -- Replace with actual script address

htmlPage :: Html ()
htmlPage = do
    doctype_
    html_ $ do
        head_ $ title_ "Charity Pool DApp"
        body_ $ do
            h1_ "Cardano Charity Pool DApp"
            p_ "Send ADA to support charity transparently."
            form_ [method_ "post"] $ do
                label_ "Amount (ADA): "
                input_ [type_ "number", name_ "amount", id_ "depositAmount"]
                input_ [type_ "submit", value_ "Deposit", id_ "depositBtn"]
            button_ [id_ "connectWalletBtn"] "Connect Wallet"
            button_ [id_ "withdrawBtn"] "Withdraw"
            p_ [id_ "status"] "Wallet not connected"
            p_ [id_ "txStatus"] ""
            script_ [src_ "wallet.js"] ""