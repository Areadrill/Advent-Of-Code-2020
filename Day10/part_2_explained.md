# Explanation of what's going on in part 2

So, since my algorithm is probably looks very weird to most readers, I wanted to break down what's happening there. First of all:

- This only works if only differences of 1 and 3 exist in the input
- I did some pracalculations by hand to smooth the process over. Is it cheating? Maybe. Did I want to move on from Haskell asap? Definitely

## Looking at a binary patterns

Let's take an abridged input for this problem:

(0) 1 2 3 4 7 (10)

Assuming that we're using all of the adapters, the joltage differences for this example are:

1, 1, 1, 1, 3, (3)

The last 3 is in parenthesis because it always exists and doesn't affect the solution.

So how many different ways can we get a 10 joltage rating on the phone? The 7jolt adapter can't be left out, and because of that the 4 jolt one can't either (since it is is the only one that can connect the rest of the adapters to the 7jolt one).

That leaves the 1, 2 and 3jolt adapters as variables. Now, to visualize how many adapters arrangements are available here, I'm going to define the adapters as being in the arrangement (1) or out of it (0):

0 0 1
0 1 0
0 1 1
1 0 0
1 0 1
1 1 0
1 1 1

7 valid arrangements for 3 variables. We can easily conclude that for 2 variables thare would be 4 choices (all of the cases where the first adapter is used in the visualization above) and that 1 variable yields 2 choices,

We can also see that these arrangements are essentially a list of contiguous base-2 numbers.

 This example already offers a glimpse into a binary pattern. Let's extend this to four variables:

0 0 1 0
 ...
0 1 1 1

1 0 0 1
 ... 
1 1 1 1

The `...` are used here to signify that all arrangements from the base-2 number above to the one below are valid arrangements.

Why aren't all 4 bit numbers valid? Because any number with more than 2 contiguous 0 would break the chain, since the maximum over-joltage the adpaters can handle is 3 jolts.

Nonetheless, 13 valid arrangements for 4 variables. Let's now take a look at (last one, I promise) the case of 5 variables:

0 0 1 0 0

   ........................       (n = 2)

0 0 1 1 1

0 1 0 0 1

   ........................     (n = 3)

0 1 1 1 1

1 0 0 1 0

   ...

1 0 1 1 1

             (n = 4)

1 1 0 0 1

   ...

1 1 1 1 1

We can see that each of the sets is essentially one of the cases we analyzed before! Trying for n = 5, 6, 7 you can see that the patterns are the same. 

And so, the formula arises: 

for n > 4, n = (n - 1) + (n - 2) + (n - 3)

## Why though?

I didn't put too much thought into this, but it seems to me that because of the over-joltage limit of 3, we're forced to have a 1 after two 0s. I believe this coupled with the repetitive nature of numbers (in this case base-2 numbers) makes this solution possible.