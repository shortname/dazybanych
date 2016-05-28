package utils;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@EqualsAndHashCode(exclude = {"id"})
@ToString
public class StorageData {

    private int id;
    private int idMagazynu;
    private int idProduktu;
    private int ilosc;

    public void remove(int amount){
        if(amount > ilosc || amount < 0)
            throw new IllegalArgumentException();
        ilosc -= amount;
    }

}
