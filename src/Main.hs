module Main where

import Nydus.Tunnel

import Control.Monad (join)
import Options.Applicative
import System.Directory (getHomeDirectory)
import System.Exit (ExitCode, exitFailure, exitWith)
import System.Process (system)

import qualified Data.ByteString as BS
import qualified Data.Map as M

sshCmd :: Tunnel -> String
sshCmd t = "ssh -N -L " ++ show t

runTunnelCmd :: Tunnel -> IO ExitCode
runTunnelCmd t = system . sshCmd $ t

readTunnels :: FilePath -> IO (Either String TunnelMap)
readTunnels f = fmap parseTunnels (BS.readFile f)

getConfigFilePath :: IO FilePath
getConfigFilePath = fmap (++"/.nydus.yml") getHomeDirectory

withTunnels :: (TunnelMap -> IO a) -> IO a
withTunnels f = do
  tunnels <- getConfigFilePath >>= readTunnels
  either (\err -> putStrLn err >> exitFailure) f tunnels

listTunnels :: IO ()
listTunnels = withTunnels $ \ts -> mapM_ (putStrLn . format) (M.toList ts)
  where format (n, t) = "[" ++ n ++ "] " ++ show t

openTunnel :: TunnelName -> IO ()
openTunnel name = withTunnels $ \ts -> maybe unknown open (M.lookup name ts)
  where unknown = putStrLn ("Unknown tunnel '" ++ name ++ "'.") >> exitFailure
        open t = putStrLn (sshCmd t) >> runTunnelCmd t >>= exitWith

opts :: Parser (IO ())
opts = subparser
  ( command "list" (info (pure $ listTunnels) idm)
 <> command "open" (info (openTunnel <$> argument str idm) idm)
  )

main :: IO ()
main = join $ execParser (info opts idm)
