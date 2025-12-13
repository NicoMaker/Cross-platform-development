# cats or dogs?

L'obiettivo di questa app è scorrere una GRIGLIA (scrollabile) dei vostri animaletti preferiti!

## requisiti

scorrere una lista di "razze"
quando clicco su una razza, vedo la pagina di dettaglio che mostra una griglia di foto di quella razza

ESEMPIO
    labrador
    bassotto (*) -->
                    [
                        [foto 1]  [foto 2]  [foto 3]
                    ]
    lagotto


infine, è possibile aggiungere ai preferiti una o più razze
quindi, ci teniamo in memoria quali sono, ed è possibile cliccare alla lista delle razze preferite e rimuoverle

## ti piacciono i cani?

lista di razze:
    - https://dog.ceo/api/breeds/list/all
immagini:
    - https://dog.ceo/api/breed/[breed_id]/images


## ti piacciono i gatti?

lista di razze:
    - https://api.thecatapi.com/v1/breeds
immagini:
    - https://api.thecatapi.com/v1/images/search?breed_id=[breed_id]&limit=10
