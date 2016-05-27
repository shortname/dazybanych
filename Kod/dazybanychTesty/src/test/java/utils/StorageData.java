package utils;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@EqualsAndHashCode
public class StorageData {

    private int id;
    private int idMagazynu;
    private int idProduktu;
    private int ilosc;

}
