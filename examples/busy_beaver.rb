module TuringMachine where

-- Tape ------------------------------------------------------------------------

data Symbol a = Char a | Blank
        deriving (Show, Eq)

data Tape a = Symbol a (Tape a) | EOT
        deriving (Show, Eq)

data Direction = L | R | Accept | Reject
        deriving (Show, Eq)

data WholeTape a = Tapes (Tape a) (Tape a) Direction
        deriving (Show, Eq)

direction_of (Tapes a b direction) = direction

flip_tape (Tapes a b L) = Tapes b a R
flip_tape (Tapes a b R) = Tapes b a L

read_t (Tapes a (Symbol read (b)) d) = read
read_t (Tapes a (EOT) d) = Blank

next (Tapes a (Symbol move (b)) d) =
         Tapes ((Symbol move) (a)) b d

write (Tapes a (Symbol move (b)) d) write direction
      | direction == d = Tapes ((Symbol write) (a)) b d
      | otherwise      = flip_tape (Tapes a (Symbol write (b)) d)

write (Tapes a (EOT) d) Blank direction
      | direction == d = error "Cannot go any further to blank tape"
      | otherwise      = flip_tape (Tapes a (EOT) d) 

-- tape :: a -> Tape a -> Tape a -> WholeTape a
tape symbols = Tapes EOT (read_tape symbols) R

read_tape [] = EOT
read_tape (symbol:symbols) = 
    (Symbol (Char symbol)) (read_tape symbols)


join_tapes (Tapes a b L) = join_tapes (Tapes b a R)
join_tapes (Tapes EOT b d) = b
join_tapes (Tapes (Symbol move (a)) b d) =
      join_tapes (Tapes a ((Symbol move) (b)) d)

extract_tape (Symbol (Char a) (b)) = a:extract_tape(b)
extract_tape (Symbol Blank (b)) = '_':extract_tape(b)
extract_tape (EOT) = ""


-- Machine ---------------------------------------------------------------------

data Instruction a = Move Int (Symbol a) (Symbol a) Direction Int
        deriving (Show, Eq)

extract_tapes (t:tapes) = (extract_tape (join_tapes t)):extract_tapes(tapes) 
extract_tapes [] = [] 

r_continue (a, _, _) = a
r_state    (_, b, _) = b
r_tape     (_, _, c) = c

machine head tape state [] = machine head tape state [tape] 
machine head tape state progress = let r = (head state tape)
    in if (r_continue r)
       then machine head (r_tape r) (r_state r) ((r_tape r):progress)
       else reverse (extract_tapes progress)



-- Heads -----------------------------------------------------------------------

instruction_for [] s ch tape =  
    error (
        "No instruction for state: " ++ (show s) ++ " symbol " ++
        (show ch) ++ " tape: " ++ (show (extract_tape (join_tapes tape)))
    ) 

instruction_for ((Move state read write direction state2):instructions) s char tape = 
    if state == s && read == char then (Move state read write direction state2)
    else instruction_for (instructions) s char tape
        
instructed_head instructions state tape = 
    tranform_tape tape (
        instruction_for instructions state (read_t tape) tape
    )
    
tranform_tape tape (Move state read w direction state2)
    | direction == Accept = (False, state2, (write tape w direction))    
    | otherwise           = (True,  state2, (write tape w direction))    


-- Examples --------------------------------------------------------------------


replace_a_with_b = 
    machine (
        instructed_head [
            (Move 0 (Char 'a') (Char 'b') R 0),
            (Move 0 (Blank) (Blank) Accept 0)
          ]) (
            tape "aaaaa"
          ) 0 []

replace_a_with_b2 = 
    machine (
        instructed_head [
            (Move 0 (Char 'a') (Char 'a') R 0),
            (Move 0 (Blank) (Blank) L 1),
            (Move 1 (Char 'a') (Char 'b') L 1),
            (Move 1 (Blank) (Blank) Accept 1)
          ]) (
            tape "aaaa"
          ) 0 []