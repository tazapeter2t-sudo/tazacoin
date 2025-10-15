;; title: TazaCoin
;; version: 1.0.0
;; summary: TazaCoin - A fungible token implementation on Stacks blockchain
;; description: TazaCoin is a SIP-010 compliant fungible token with mint, burn, and transfer capabilities

;; traits
;; SIP-010 compliant fungible token (trait implementation can be added when deploying to mainnet)

;; token definitions
(define-fungible-token tazacoin)

;; constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_OWNER_ONLY (err u100))
(define-constant ERR_NOT_TOKEN_OWNER (err u101))
(define-constant ERR_INSUFFICIENT_BALANCE (err u102))
(define-constant ERR_INVALID_AMOUNT (err u103))
(define-constant TOKEN_NAME "TazaCoin")
(define-constant TOKEN_SYMBOL "TAZA")
(define-constant TOKEN_DECIMALS u6)
(define-constant TOKEN_URI "https://tazacoin.io/metadata.json")

;; data vars
(define-data-var token-total-supply uint u0)
(define-data-var contract-paused bool false)

;; data maps
(define-map token-balances principal uint)
(define-map allowances {owner: principal, spender: principal} uint)

;; SIP-010 Standard Functions

;; Transfer function
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (not (var-get contract-paused)) (err u104))
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (is-eq from tx-sender) ERR_NOT_TOKEN_OWNER)
    (try! (ft-transfer? tazacoin amount from to))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; Get name
(define-read-only (get-name)
  (ok TOKEN_NAME)
)

;; Get symbol
(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

;; Get decimals
(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

;; Get balance
(define-read-only (get-balance (who principal))
  (ok (ft-get-balance tazacoin who))
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (ft-get-supply tazacoin))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok (some TOKEN_URI))
)

;; Administrative Functions

;; Mint tokens (only owner)
(define-public (mint (amount uint) (to principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_OWNER_ONLY)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-mint? tazacoin amount to)
  )
)

;; Burn tokens
(define-public (burn (amount uint) (from principal))
  (begin
    (asserts! (not (var-get contract-paused)) (err u104))
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (is-eq from tx-sender) ERR_NOT_TOKEN_OWNER)
    (ft-burn? tazacoin amount from)
  )
)

;; Pause/unpause contract (only owner)
(define-public (set-contract-paused (paused bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_OWNER_ONLY)
    (var-set contract-paused paused)
    (ok true)
  )
)

;; Additional utility functions

;; Check if contract is paused
(define-read-only (is-paused)
  (ok (var-get contract-paused))
)

;; Get contract owner
(define-read-only (get-contract-owner)
  (ok CONTRACT_OWNER)
)

;; Multi-send function for airdrops
(define-public (multi-send (recipients (list 200 {to: principal, amount: uint})))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_OWNER_ONLY)
    (asserts! (not (var-get contract-paused)) (err u104))
    (ok (map multi-send-helper recipients))
  )
)

;; Helper function for multi-send
(define-private (multi-send-helper (recipient {to: principal, amount: uint}))
  (ft-mint? tazacoin (get amount recipient) (get to recipient))
)

;; Batch transfer function
(define-public (batch-transfer (transfers (list 200 {to: principal, amount: uint, memo: (optional (buff 34))})))
  (begin
    (asserts! (not (var-get contract-paused)) (err u104))
    (ok (map batch-transfer-helper transfers))
  )
)

;; Helper function for batch transfer
(define-private (batch-transfer-helper (transfer-data {to: principal, amount: uint, memo: (optional (buff 34))}))
  (begin
    (try! (ft-transfer? tazacoin (get amount transfer-data) tx-sender (get to transfer-data)))
    (match (get memo transfer-data) to-print (print to-print) 0x)
    (ok true)
  )
)
