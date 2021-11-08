Class BO.Voiture Extends Ens.BusinessOperation
{

Property Adapter As Ens.OutboundAdapter;

Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method creerVoiture(pRequest As msg.creerVoitureDmde, Output pResponse As msg.creerVoitureRpse) As %Status
{
    
    set pResponse = ##class(msg.creerVoitureRpse).%New()
    set voiture = ##class(data.Voiture).%New()
    do ##class(Transform.WsVoitureToVoiture).Transform(pRequest.voiture,.voiture)
    set tsc = voiture.%Save()

    set pResponse.codeRetour = "OK"

    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="msg.creerVoitureDmde">
        <Method>creerVoiture</Method>
    </MapItem>
     <MapItem MessageType="msg.supprimerVoitureDmde">
        <Method>supprimerVoiture</Method>
    </MapItem>
</MapItems>
}

Method supprimerVoiture(pRequest As msg.supprimerVoitureDmde, Output pResponse As msg.supprimerVoitureRpse) As %Status
{
    
    set pResponse = ##class(msg.supprimerVoitureRpse).%New()
    if (##class(data.Voiture).consulterParPlaqueExists(pRequest.plaque, .idVoiture)){
        set voiture = ##class(data.Voiture).%DeleteId(idVoiture)
        if 'voiture{
            set pResponse.codeRetour = "KO"
            set pResponse.libErreur = "Erreur technique lors de la suppression"
            QUIT $$$OK
        }
    }
    else {
        set pResponse.codeRetour = "KO"
        set pResponse.libErreur = "Plaque introuvable"
        QUIT $$$OK
    }
    set pResponse.codeRetour = "OK"

    Quit $$$OK
}

}
