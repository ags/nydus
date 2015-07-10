{-# LANGUAGE OverloadedStrings #-}

module Nydus.Tunnel
  ( Tunnel(..)
  , TunnelName
  , TunnelMap
  , parseTunnels
  ) where

import Control.Monad (mzero)
import Data.Yaml
import qualified Data.ByteString as BS
import qualified Data.Map as M

data Tunnel = Tunnel { tPort :: Int
                     , tHost :: String
                     , tHostPort :: Int
                     , tUsername :: String
                     , tHostname :: String
                     }

type TunnelName = String

type TunnelMap = M.Map TunnelName Tunnel

instance FromJSON Tunnel where
  parseJSON (Object v) =
    Tunnel <$> v .: "port"
           <*> v .: "host"
           <*> v .: "hostport"
           <*> v .: "username"
           <*> v .: "hostname"
  parseJSON _ = mzero

instance Show Tunnel where
  show t =
    (show . tPort $ t) ++ ":" ++ (tHost t) ++ ":" ++ (show . tHostPort $ t)
    ++ " "
    ++ (tUsername t) ++ "@" ++ (tHostname t)

parseTunnels :: BS.ByteString -> Either String TunnelMap
parseTunnels f = decodeEither f
