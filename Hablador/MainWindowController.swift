//
//  MainWindowController.swift
//  Hablador
//
//  Created by Leonardo Guzman on 2/12/17.
//  Copyright © 2017 Leonardo Guzman. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {

    
    // MARK: - Atributos
    @IBOutlet weak var hablarBoton : NSButton?;
    @IBOutlet weak var detenerBoton : NSButton?;
    @IBOutlet weak var textoTextfield : NSTextField?;
    @IBOutlet weak var vocesTableView : NSTableView?;
    
    
    let speechSynth = NSSpeechSynthesizer()
    
    let voces = NSSpeechSynthesizer.availableVoices();
    
    var activado = false {
        //Metodo que se ejecuta cuando existe un cambio en la variable
        didSet{
            editarBotones();
        }
    };
    
    // MARK: - Metodos obligatorios
    
    override var windowNibName: String?{
        return "MainWindowController";
    }
    
    
    override func windowDidLoad() {
        
        super.windowDidLoad();
        editarBotones();
        speechSynth.delegate = self;
        
        let defaultRow = obtenerVozPorDefecto();
        
        if let fila = defaultRow{
            if let control = vocesTableView {
            
                let indices = NSIndexSet(index: fila);
                control.selectRowIndexes(indices as IndexSet, byExtendingSelection: false)
                control.scrollRowToVisible(fila);
            }
        }
    }
    
    
    // MARK: - Metodos privados
    
    func obtenerNombreVoz(_ identificador : String) -> String? {
        
        let atributos = NSSpeechSynthesizer.attributes(forVoice: identificador);
        let retorno = atributos[NSVoiceName] as? String
        
        return retorno;
        
    }
    
    
    func obtenerVozPorDefecto( ) -> Int? {
        
        let defaultVoice = NSSpeechSynthesizer.defaultVoice();
        let retorno = voces.index(of: defaultVoice);
        
        return retorno;
        
    }
    
    //Metodo que edita los estados de los botones
    func editarBotones() {
        
        if let control = hablarBoton {
            control.isEnabled = !activado;
        }
        
        if let control = detenerBoton {
            control.isEnabled = activado;
        }
    }
    
    //# MARK: - Eventos
    
    
    //Metodo que se ejecuta cuando se da click al boton hablar
    @IBAction func onClickHablar(sender : NSButton) {
        
        if let control = textoTextfield{
            
            var texto = control.stringValue;
            
            if texto.isEmpty {
                texto = "No ha escrito nada";
            }
            
            activado = true;
            speechSynth.startSpeaking( texto );
        }
    }
    
    
    //Metodo que se ejecuta cuando se da click al boton detener
    @IBAction func onClickDetener(sender : NSButton) {
    
        speechSynth.stopSpeaking();
    }
    
    
    // MARK: - NSSpeechSynthesizerDelegate
    
    //Metodo del delegado de speech que me permite atajar cuando ha acabado de hablar la maquina
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        
        activado = false;
    }
    
    
    // MARK: - NSWindowDelegate
    
    //Metodo que ataja el evento de cerrar de la ventana
    public func windowShouldClose(_ sender: Any) -> Bool {
        return !activado;
    }
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return voces.count;
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let voz = voces[row];
        let nombreVoz = obtenerNombreVoz(voz);
        
        return nombreVoz;
    }
    
    // MARK: - NSTableViewDelegate
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        
        if let control = vocesTableView {
            
            let fila = control.selectedRow;
            
            if fila == -1 {
                speechSynth.setVoice(nil);
            }
            else {
                let voz = voces[ fila ];
                speechSynth.setVoice( voz );
            }
            
        }
    }
}
