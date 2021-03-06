module Masks where

import Prelude hiding ((++))

import Data.Bits
import Data.Word

import Data.Vector.Unboxed
import qualified Data.Vector.Unboxed as U
import qualified Data.Vector as V
import MoveTables

type Mask = Word64

makeLine :: Int -> Int -> Word64
makeLine start delta = U.foldl' setBit 0 $ enumFromStepN start delta 8

rank1M, rank2M, rank3M, rank4M, rank5M, rank6M, rank7M, rank8M :: Mask
rank1M = 0x00000000000000FF
rank2M = 0x000000000000FF00
rank3M = 0x0000000000FF0000
rank4M = 0x00000000FF000000
rank5M = 0x000000FF00000000
rank6M = 0x0000FF0000000000
rank7M = 0x00FF000000000000
rank8M = 0xFF00000000000000

rankMasks :: Vector Word64
rankMasks = fromList [rank1M,rank2M,rank3M,rank4M,rank5M,rank6M,rank7M,rank8M]

fileAM, fileBM, fileCM, fileDM, fileEM, fileFM, fileGM, fileHM :: Mask
fileAM = 0x0101010101010101
fileBM = 0x0202020202020202
fileCM = 0x0404040404040404
fileDM = 0x0808080808080808
fileEM = 0x1010101010101010
fileFM = 0x2020202020202020
fileGM = 0x4040404040404040
fileHM = 0x8080808080808080

fileMasks :: Vector Mask
fileMasks = fromList [fileAM,fileBM,fileCM,fileDM,fileEM,fileFM,fileGM,fileHM]

rookMasks :: Vector Mask
rookMasks = U.concatMap (\b1 -> U.map (b1 .|.) fileMasks) rankMasks
--rookMasks = U.concatMap (\b1 -> U.map (\b2 -> (b1 .|. b2) `xor` (b1 .&. b2)) fileMasks) rankMasks

bishopMasks :: Vector Mask
bishopMasks = gSlidingAttack attackTransform
  where attackTransform i = fmap (fmap (i +)) $ V.fromList [V.enumFromStepN 0 11 8,
                                                    V.enumFromStepN 0 (-11) 8,
                                                    V.enumFromStepN 0 9 8,
                                                    V.enumFromStepN 0 (-9) 8]
