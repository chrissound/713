{-# LANGUAGE OverloadedStrings #-}  

module Main where

import Discord
import Discord.Types
import qualified Data.Text.IO as TIO
import Discord.Internal.Rest.ApplicationCommands
import Discord.Internal.Types.ApplicationCommands
import Discord.Internal.Types.Events
import Discord.Internal.Types.Interactions
import Control.Monad.IO.Class


appId = 0
token = ""

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  t <- runDiscord $ def { discordToken = token
                        , discordOnStart = startHandler
                        , discordOnEnd = putStrLn "Ended"
                        , discordOnEvent = eventHandler
                        , discordOnLog = \s -> TIO.putStrLn s >> TIO.putStrLn ""
                        --, discordGatewayIntent = def
                        , discordGatewayIntent = GatewayIntent {
                                  gatewayIntentGuilds                 = True 
                                , gatewayIntentMembers                = False  -- false
                                , gatewayIntentBans                   = False 
                                , gatewayIntentEmojis                 = False 
                                , gatewayIntentIntegrations           = False 
                                , gatewayIntentWebhooks               = False 
                                , gatewayIntentInvites                = False 
                                , gatewayIntentVoiceStates            = False 
                                , gatewayIntentPrecenses              = False   -- false
                                , gatewayIntentMessageChanges         = True
                                , gatewayIntentMessageReactions       = False 
                                , gatewayIntentMessageTyping          = False 
                                , gatewayIntentDirectMessageChanges   = False 
                                , gatewayIntentDirectMessageReactions = False 
                                , gatewayIntentDirectMessageTyping    = False 
                                , gatewayIntentMessageContent         = False 
                                }
                        }
  print "Done"

basicCallFetch v = do
    restCall v >>= \case
      Right v' -> pure v'
      Left e -> error $ show e

startHandler :: DiscordHandler ()
startHandler = do
  let v = [
            ApplicationCommandOptionValueInteger "example" "zzzzzz" True (Left False) (Nothing) (Nothing)
          ]
  liftIO $ print "1"

  let f d = basicCallFetch $ CreateGlobalApplicationCommand appId $ (CreateApplicationCommandChatInput "configure123" d (Just $ ApplicationCommandOptionsValues v) True)

  -- this fails silently? 
  f ""
  -- f "this does not"

  liftIO $ print "2"

eventHandler :: Event -> DiscordHandler ()
eventHandler = const $ pure ()
