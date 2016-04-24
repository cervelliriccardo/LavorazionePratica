USE [LavorazionePratica]
GO

SET DATEFORMAT ymd
GO 

SET NOCOUNT ON

INSERT INTO [TipoLavorazioni] ([idTipoLavorazione], [Descrizione]) VALUES (1, N'Rinnovo contratto')

INSERT INTO [TipoLavorazioni] ([idTipoLavorazione], [Descrizione]) VALUES (2, N'Fattura insoluta')

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (-1, NULL, N'Categoria per il messaggio di cortesia', 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (1, N'Contatto', N'Contatto', 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (2, N'Contratto', N'Contratto', 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (3, N'Reclami', N'Reclami', 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (4, N'Consapevolezza', N'Consapevolezza', 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (5, N'Recapito', NULL, 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (6, N'Contatti', NULL, 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (7, N'Pagamento', NULL, 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (8, N'Reclami', NULL, 0, NULL, NULL)

INSERT INTO [CategorieAttributi] ([idCategoria], [Descrizione], [DescrizioneInterna], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (9, N'Recupero Crediti', NULL, 0, NULL, NULL)

SET IDENTITY_INSERT [Attributi] ON

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (-1, -1, N'Trascina qui gli attributi', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (1, 1, N'Cambiato indirizzo', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (2, 1, N'Cambiato telefono', 1, N'Numero di telefono', 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (3, 1, N'Cambiata email', 1, N'Email', 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (4, 2, N'Rinnova', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (5, 2, N'Non rinnova', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (6, 2, N'Richiede sconto', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (7, 3, N'Chiarezza fattura', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (8, 3, N'Qualità del servizio', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (9, 3, N'Tempi di attesa call center', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (10, 4, N'Consapevole', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (11, 4, N'Inconsapevole', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (12, 5, N'Fattura ricevuta', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (13, 5, N'Fattura non ricevuta', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (14, 6, N'Invio cartaceo', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (15, 6, N'Invio email', 1, N'Email', 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (16, 6, N'Invio sms emissione', 1, N'Cellulare', 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (17, 7, N'Pagata', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (18, 7, N'Pagherà', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (19, 7, N'Non pagherà', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (20, 8, N'Insoddisfatto servizio', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (21, 8, N'Richiede sconto', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (22, 8, N'Rescinde contratto', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (23, 9, N'Invio a recupero crediti', 0, NULL, 0, NULL, NULL)

INSERT INTO [Attributi] ([idAttributo], [Categoria], [Descrizione], [HasValue], [DescrizioneValore], [Cancellato], [IdUtenteCancellazione], [DataCancellazione]) VALUES (24, 9, N'Invio a legale', 0, NULL, 0, NULL, NULL)

SET IDENTITY_INSERT [Attributi] OFF
GO 

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (1, -1, 1)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (1, 1, 3)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (1, 2, 2)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (1, 3, 4)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, -1, 1)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 4, 2)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 5, 3)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 6, 4)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 7, 5)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 8, 6)

INSERT INTO [CategorieTipoLavorazioni] ([TipoLavorazione], [Categoria], [Ordine]) VALUES (2, 9, 7)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (-1, -1, 1)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (-1, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (1, -1, 1)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (2, -1, 1)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (3, -1, 1)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (4, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (5, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (6, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (7, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (8, -1, 2)

INSERT INTO [EsclusioniCategorie] ([Categoria], [CategoriaEsclusa], [TipoLavorazione]) VALUES (9, -1, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (4, 5, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (5, 1, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (5, 2, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (5, 3, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (5, 4, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (5, 6, 1)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (10, 11, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (11, 10, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (12, 13, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (13, 12, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (14, 15, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (15, 14, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (17, 18, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (17, 19, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (18, 17, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (18, 19, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (19, 17, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (19, 18, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (23, 24, 2)

INSERT INTO [EsclusioniAttributi] ([Attributo], [AttributoEscluso], [TipoLavorazione]) VALUES (24, 23, 2)

