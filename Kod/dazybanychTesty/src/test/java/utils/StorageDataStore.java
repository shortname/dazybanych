package utils;

import lombok.Getter;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class StorageDataStore {

    List<StorageData> storageData;

    public StorageDataStore(){
        storageData = new ArrayList<>();
    }

    public boolean add(StorageData storageData) {
        return this.storageData.add(storageData);
    }

    public List<OrderDetails> realizeOrder(int productId, int amount, int orderId){
        List<OrderDetails> result = new ArrayList<>();
        while(amount > 0){
            StorageData storage = storageData.stream()
                    .filter(sd -> sd.getIdProduktu() == productId)
                    .sorted(Comparator.comparingInt((StorageData sd) -> sd.getIlosc()).reversed())
                    .findAny()
                    .orElseThrow(IllegalArgumentException::new);
            int found = storage.getIlosc();
            if(found >= amount) {
                storage.remove(amount);
                result.add(new OrderDetails(storage.getIdMagazynu(), productId, amount));
                amount = 0;
            }else{
                storageData.remove(storage);
                result.add(new OrderDetails(storage.getIdMagazynu(), productId, found));
                amount -= found;
            }
        }
        storageData = storageData.stream().filter(sd -> sd.getIlosc() != 0).collect(Collectors.toList());
        return result;
    }
}
