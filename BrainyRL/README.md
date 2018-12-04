# Brainy RL
## Reinforcement Learning Library for iOS

### Reward Maximization
The RL agent basically works on a hypothesis of **reward maximization**. 
That’s why reinforcement learning should have best possible action in order to maximize the reward. **G**

![](https://cdn-images-1.medium.com/max/1600/1*up3hsG1ToqndcnmdA8tbRw.png)

#### Discounting of rewards works like this:
We define a *discount rate* called *gamma*. Its value should be between `0 and 1`. The larger the *gamma*, the smaller the discount and vice versa.

![](https://cdn-images-1.medium.com/max/2000/1*ef-5D-aBUShEnvMjiCujNw.png)

#### Continuous tasks
These are the types of **tasks that continue forever**. For instance, Forex trading. The RL Agent has to **keep running** until we decide to manually stop it.

#### Episodic task
In this case, we have a **starting point** and an **ending point** called the **terminal state**. 

This creates an **Episode**: A **list of** States (**S**), Actions (**A**) and Rewards (**R**).

## Approaches to Reinforcement Learning

1.- **Policy-based approach**:

We have a **Policy which we need to optimize**. The policy basically defines how the agent behaves **a = pi(s)**:

* Where: 

- **a**: Actions
- **s**: State
- **pi**: Policy function

We learn a **policy function** which helps us in **mapping each state** to the best action.

* Two types of Policies:

- **Deterministic**: a policy at a given state **(s)** will always return the same action **(a)**. It means, it is pre-mapped as **S=(s) ➡ A=(a)**.

- **Stochastic**: It gives a *distribution of probability* over different actions. i.e Stochastic Policy ➡ **p( A = a | S = s )**

2.- **Value-based approach**:

Here we optimize the value function *V(s)* which is defined as a function that tell us the maximum expected **future reward** the agent shall **get at each state**.
*The value of each state* is the **total** amount of **reward** an agent can expect to collect over the future from a particular state.

![](https://cdn-images-1.medium.com/max/1600/0*kvtRAhBZO-h77Iw1.)

The agent will use the above value function to select which state to choose at each step. The agent will always take the state with the biggest value.


### Policy Gradient
The algorithm produces a random output which gives a reward and this is fed back to the algorithm/network. This is an iterative process.
In the context of the game, the score board acts as a reward or feed back to the agent. Whenever the agent tends to score +1, it understands that the action taken by it was good enough at that state.

### Q-Learning
Q-learning is a values-based learning algorithm in reinforcement learning.

**Q-Table**: 
A table where we calculate the maximum expected future rewards for action at each state.

**Q-function**:
The Q-function uses the Bellman equation and takes two inputs: state **(s)** and action **(a)**.
Using the function, we get the values of Q for the cells in the table.
![](https://cdn-images-1.medium.com/max/1600/1*trCNkfvyNnokeKhYUlJxfg.png)

When we start, all the values in the Q-table are zeros.

#### References:

Reinforcement Learning an Introduction, second edition, Richard A. Sutton and Andrew G. Barto

[Medium - A brief introduction to reinforcement learning](https://medium.freecodecamp.org/a-brief-introduction-to-reinforcement-learning-7799af5840db)

https://medium.freecodecamp.org/diving-deeper-into-reinforcement-learning-with-q-learning-c18d0db58efe


