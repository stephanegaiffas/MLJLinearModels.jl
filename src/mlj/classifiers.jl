#= ===================
   LOGISTIC CLASSIFIER
   =================== =#

"""
$SIGNATURES

Logistic Classifier (typically called "Logistic Regression"). This model is
a standard classifier for both binary and multiclass classification.
In the binary case it corresponds to the LogisticLoss, in the multiclass to the
Multinomial (softmax) loss. An elastic net penalty can be applied with
overall objective function

``L(y, Xθ) + λ|θ|₂²/2 + γ|θ|₁``

Where `L` is either the logistic or multinomial loss and `λ` and `γ` indicate
the strength of the L2 (resp. L1) regularisation components.

## Parameters
* `penalty` (Symbol or String): the penalty to use, either `:l2`, `:l1`, `:en`
                                (elastic net) or `:none`. (Default: `:l2`)
* `lambda` (Real): strength of the regulariser if `penalty` is `:l2` or `:l1`.
                   Strength of the L2 regulariser if `penalty` is `:en`.
* `gamma` (Real): strength of the L1 regulariser if `penalty` is `:en`.
* `fit_intercept` (Bool): whether to fit an intercept (Default: `true`)
* `penalize_intercept` (Bool): whether to penalize intercept (Default: `false`)
* `solver` (Solver): type of solver to use, default if `nothing`.
* `multi_class` (Bool): whether it's a binary or multi class classification
                        problem. This is usually set automatically.
"""
@with_kw_noshow mutable struct LogisticClassifier <: MMI.Probabilistic
    lambda::Real             = 1.0
    gamma::Real              = 0.0
    penalty::SymStr          = :l2
    fit_intercept::Bool      = true
    penalize_intercept::Bool = false
    solver::Option{Solver}   = nothing
    multi_class::Bool        = false
    nclasses::Int            = 2
end

glr(m::LogisticClassifier) =
    LogisticRegression(m.lambda, m.gamma;
                       penalty=Symbol(m.penalty),
                       multi_class=m.multi_class,
                       fit_intercept=m.fit_intercept,
                       penalize_intercept=m.penalize_intercept,
                       nclasses=m.nclasses)

descr(::Type{LogisticClassifier}) = "Classifier corresponding to the loss function ``L(y, Xθ) + λ|θ|₂²/2 + γ|θ|₁`` where `L` is the logistic loss."

#= ======================
   MULTINOMIAL CLASSIFIER
   ====================== =#

"""
$SIGNATURES

See `LogisticClassifier`, it's the same except that `multi_class` is set
to `true` by default. The other parameters are the same.
"""
@with_kw_noshow mutable struct MultinomialClassifier <: MMI.Probabilistic
    lambda::Real             = 1.0
    gamma::Real              = 0.0
    penalty::SymStr          = :l2
    fit_intercept::Bool      = true
    penalize_intercept::Bool = false
    solver::Option{Solver}   = nothing
    nclasses::Int            = 2       # leave to 2, cf LogisticRegression
end

glr(m::MultinomialClassifier) =
    MultinomialRegression(m.lambda, m.gamma;
                          penalty=Symbol(m.penalty),
                          fit_intercept=m.fit_intercept,
                          penalize_intercept=m.penalize_intercept,
                          nclasses=m.nclasses)

descr(::Type{MultinomialClassifier}) =
    "Classifier corresponding to the loss function " *
    "``L(y, Xθ) + λ|θ|₂²/2 + γ|θ|₁`` where `L` is the multinomial loss."
