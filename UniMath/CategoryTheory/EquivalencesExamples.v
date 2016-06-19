(**

This file contains some adjunctions:

- The binary delta_functor is left adjoint to binproduct_functor

- The general delta functor is left adjoint to the general product
  functor

- The bincoproduct_functor is left adjoint to the binary delta functor

- The general coproduct functor is left adjoint to the general delta
  functor

Written by: Anders Mörtberg, 2016

*)
Require Import UniMath.Foundations.Basics.PartD.
Require Import UniMath.Foundations.Basics.Propositions.
Require Import UniMath.Foundations.Basics.Sets.

Require Import UniMath.CategoryTheory.precategories.
Require Import UniMath.CategoryTheory.BinProductPrecategory.
Require Import UniMath.CategoryTheory.ArbitraryProductPrecategory.
Require Import UniMath.CategoryTheory.functor_categories.
Require Import UniMath.CategoryTheory.equivalences.
Require Import UniMath.CategoryTheory.limits.binproducts.
Require Import UniMath.CategoryTheory.limits.arbitrary_products.
Require Import UniMath.CategoryTheory.limits.bincoproducts.
Require Import UniMath.CategoryTheory.limits.arbitrary_coproducts.

Section delta_functor_adjunction.

Context {C : precategory} (PC : BinProducts C).

(** The binary delta_functor is left adjoint to binproduct_functor *)
Lemma is_left_adjoint_delta_functor : is_left_adjoint (delta_functor C).
Proof.
apply (tpair _ (binproduct_functor PC)).
mkpair.
- split.
  + mkpair.
    * simpl; intro x.
      apply (BinProductArrow _ _ (identity x) (identity x)).
    * abstract (intros p q f; simpl;
                now rewrite precompWithBinProductArrow, id_right, postcompWithBinProductArrow, id_left).
  + mkpair.
    * simpl; intro x; split; [ apply BinProductPr1 | apply BinProductPr2 ].
    * abstract (intros p q f; unfold binprodcatmor, compose; simpl;
                now rewrite BinProductOfArrowsPr1, BinProductOfArrowsPr2).
- abstract (split; simpl; intro x;
  [ unfold binprodcatmor, compose; simpl;
    now rewrite BinProductPr1Commutes, BinProductPr2Commutes
  | rewrite postcompWithBinProductArrow, !id_left;
    apply pathsinv0, BinProduct_endo_is_identity;
      [ apply BinProductPr1Commutes | apply BinProductPr2Commutes ]]).
Defined.

End delta_functor_adjunction.

Section arbitrary_delta_functor_adjunction.

Context (I : UU) {C : precategory} (PC : ArbitraryProducts I C).

(** The general delta functor is left adjoint to the general product functor *)
Lemma is_left_adjoint_arbitrary_delta_functor :
  is_left_adjoint (arbitrary_delta_functor I C).
Proof.
apply (tpair _ (arbitrary_product_functor _ PC)).
mkpair.
- split.
  + mkpair.
    * simpl; intro x.
      apply (ArbitraryProductArrow _ _ _ (fun _ => identity x)).
    * abstract (intros p q f; simpl;
                now rewrite precompWithArbitraryProductArrow, id_right,
                            postcompWithArbitraryProductArrow, id_left).
  + mkpair.
    * intros x i; apply ArbitraryProductPr.
    * abstract (intros p q f; apply funextsec; intro i; unfold compose; simpl;
                now rewrite ArbitraryProductOfArrowsPr).
- abstract (split; simpl; intro x;
    [ apply funextsec; intro i; apply (ArbitraryProductPrCommutes _ _ (fun _ => x))
    | rewrite postcompWithArbitraryProductArrow;
      apply pathsinv0, ArbitraryProduct_endo_is_identity; intro i;
      eapply pathscomp0; [|apply (ArbitraryProductPrCommutes I C _ (PC x))];
      apply cancel_postcomposition, maponpaths, funextsec; intro j; apply id_left]).
Defined.

End arbitrary_delta_functor_adjunction.

Section bincoproduct_functor_adjunction.

Context {C : precategory} (PC : BinCoproducts C).

(** The bincoproduct_functor left adjoint to delta_functor *)
Lemma is_left_adjoint_bincoproduct_functor : is_left_adjoint (bincoproduct_functor PC).
Proof.
apply (tpair _ (delta_functor _)).
mkpair.
- split.
  + mkpair.
    * simpl; intro p; set (x := pr1 p); set (y := pr2 p).
      split; [ apply (BinCoproductIn1 _ (PC x y)) | apply (BinCoproductIn2 _ (PC x y)) ].
    * abstract (intros p q f; unfold binprodcatmor, compose; simpl;
                now rewrite BinCoproductOfArrowsIn1, BinCoproductOfArrowsIn2).
  + mkpair.
    * intro x; apply (BinCoproductArrow _ _ (identity x) (identity x)).
    * abstract (intros p q f; simpl;
                now rewrite precompWithBinCoproductArrow, postcompWithBinCoproductArrow,
                            id_right, id_left).
- abstract (split; simpl; intro x;
  [ rewrite precompWithBinCoproductArrow, !id_right;
    apply pathsinv0, BinCoproduct_endo_is_identity;
      [ apply BinCoproductIn1Commutes | apply BinCoproductIn2Commutes ]
  | unfold binprodcatmor, compose; simpl;
    now rewrite BinCoproductIn1Commutes, BinCoproductIn2Commutes ]).
Defined.

End bincoproduct_functor_adjunction.

Section arbitrary_coproduct_functor_adjunction.

Context (I : UU) {C : precategory} (PC : ArbitraryCoproducts I C).

(** The general coproduct functor left adjoint to the general delta functor *)
Lemma is_left_adjoint_arbitrary_indexed_coproduct_functor :
  is_left_adjoint (arbitrary_indexed_coproduct_functor I PC).
Proof.
apply (tpair _ (arbitrary_delta_functor _ _)).
mkpair.
- split.
  + mkpair.
    * intros p i; apply ArbitraryCoproductIn.
    * abstract (intros p q f; apply funextsec; intro i; unfold compose; simpl;
                now rewrite ArbitraryCoproductOfArrowsIn).
  + mkpair.
    * intro x; apply (ArbitraryCoproductArrow _ _ _ (fun _ => identity x)).
    * abstract (intros p q f; simpl;
                now rewrite precompWithArbitraryCoproductArrow,
                            postcompWithArbitraryCoproductArrow,
                            id_right, id_left).
- abstract (split; simpl; intro x;
    [ rewrite precompWithArbitraryCoproductArrow;
      apply pathsinv0, ArbitraryCoproduct_endo_is_identity; intro i;
      eapply pathscomp0; [|apply ArbitraryCoproductInCommutes];
      apply maponpaths, maponpaths, funextsec; intro j; apply id_right
    | apply funextsec; intro i; apply (ArbitraryCoproductInCommutes _ _ (fun _ => x))]).
Defined.

End arbitrary_coproduct_functor_adjunction.
