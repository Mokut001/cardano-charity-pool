{-# LANGUAGE DataKinds #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module CharityPool where

import           PlutusTx.Prelude
import           Ledger
import           Ledger.Typed.Scripts
import           Plutus.V1.Ledger.Scripts
import           PlutusTx
import           Prelude (IO, Show, String)

-- Datum: empty
data CharityDatum = CharityDatum
PlutusTx.unstableMakeIsData ''CharityDatum

-- Redeemer for owner withdraw
data CharityRedeemer = Withdraw
PlutusTx.unstableMakeIsData ''CharityRedeemer

{-# INLINABLE mkValidator #-}
mkValidator :: CharityDatum -> CharityRedeemer -> ScriptContext -> Bool
mkValidator _ r ctx = case r of
    Withdraw -> traceIfFalse "Only owner can withdraw" signedByOwner
  where
    info = scriptContextTxInfo ctx
    owner = "f1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t" -- Replace with your pub key hash
    signedByOwner = txSignedBy info owner

data Charity
instance Scripts.ValidatorTypes Charity where
    type instance RedeemerType Charity = CharityRedeemer
    type instance DatumType Charity = CharityDatum

typedValidator :: Scripts.TypedValidator Charity
typedValidator = Scripts.mkTypedValidator @Charity
    $$(PlutusTx.compile [|| mkValidator ||])
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = Scripts.wrapValidator @CharityDatum @CharityRedeemer

validator :: Validator
validator = Scripts.validatorScript typedValidator

scrAddress :: Ledger.Address
scrAddress = scriptAddress validator