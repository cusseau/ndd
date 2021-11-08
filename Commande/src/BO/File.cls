Class BO.File Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method pushVoitreFile(pRequest As msg.pushVoitureFileDmde, Output pResponse As msg.pushVoitureFileRpse) As %Status
{
    set pResponse = ##class(msg.pushVoitureFileDmde).%New()

    set file = ##class(%Library.FileBinaryStream).%New()

    do file.Write(pRequest.voiture.marque_";"_pRequest.voiture.modele_";"_pRequest.voiture.categorie_";"_pRequest.voiture.plaque_";")

    set tsc = ..Adapter.PutStream("fichierVoiture.csv", file)

    if tsc {
        set pResponse.codeRetour = "OK"
    }
    else {
        set pResponse.codeRetour = "KO"
    }
    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="msg.pushVoitureFileDmde">
        <Method>pushVoitureFile</Method>
    </MapItem>
</MapItems>
}

}
