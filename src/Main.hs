module Main where

import Nydus.Tunnel

import Control.Monad (join)
import Options.Applicative

import qualified Data.ByteString as BS
import qualified Data.Map as M

sshCmd :: Tunnel -> String
sshCmd t = "ssh -N -L " ++ show t

readTunnels :: FilePath -> IO (Either String TunnelMap)
readTunnels f = fmap parseTunnels (BS.readFile f)

doList :: FilePath -> IO ()
doList config = do
  tunnels <- readTunnels config
  case tunnels of
    Left err -> print err
    Right ts -> mapM_ (putStrLn . format) (M.toList ts)
      where format (n, t) = "[" ++ n ++ "] " ++ show t

opts :: Parser (IO ())
opts = subparser
  (command "list" (info (pure $ doList "tunnels.yml") idm))

main :: IO ()
main = join $ execParser (info opts idm)
