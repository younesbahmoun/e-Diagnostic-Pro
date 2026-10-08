<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Consultation — espace généraliste.">
    <title>Consultation — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/infirmier.css">
</head>
<body class="infirmier-page">
    <a class="skip-link" href="#contenu">Aller au contenu</a>
    <%@ include file="../fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="../fragments/generaliste-navbar.jspf" %>
        <main id="contenu">
            <div class="page-heading">
                <p class="eyebrow">Espace généraliste</p>
                <span class="page-index">CONSULTATION</span>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert" role="alert">
                    <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                    <p><c:out value="${errorMessage}" /></p>
                </div>
            </c:if>

            <c:if test="${param.demandeOk == '1'}">
                <div class="alert alert-success" role="status">
                    <svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg>
                    <p><strong>Demande envoyée.</strong>Le spécialiste a été notifié de la nouvelle demande.</p>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty consultation}">
                    <section class="panel">
                        <h2>Consultation introuvable</h2>
                        <p><a class="btn-link" href="${pageContext.request.contextPath}/generaliste/dossier">Retour à la file d&rsquo;attente</a></p>
                    </section>
                </c:when>

                <c:otherwise>
                    <div class="infirmier-intro">
                        <h1>Consultation <em>du <c:out value="${consultation.dateConsultation}" />.</em></h1>
                        <p>Patient : <c:out value="${consultation.patient.prenom}" /> <c:out value="${consultation.patient.nom}" /> — N° <c:out value="${consultation.patient.numeroSecuriteSociale}" /></p>
                    </div>

                    <section class="panel" aria-labelledby="titre-recap" style="margin-bottom: 20px;">
                        <div class="panel-head">
                            <div>
                                <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-stethoscope"/></svg> Dossier de consultation</p>
                                <h2 id="titre-recap"><c:out value="${consultation.motif}" /></h2>
                            </div>
                            <span class="status-pill"><c:out value="${consultation.statut}" /></span>
                        </div>
                        <div class="patient-recap">
                            <div><span>Patient</span><strong><c:out value="${consultation.patient.prenom}" /> <c:out value="${consultation.patient.nom}" /></strong></div>
                            <div><span>Médecin</span><strong>Dr <c:out value="${consultation.generaliste.prenom}" /> <c:out value="${consultation.generaliste.nom}" /></strong></div>
                            <div><span>Coût</span><strong><c:out value="${consultation.cout}" /> DH</strong></div>
                        </div>
                        <p><strong>Examen clinique et observations :</strong><br><c:out value="${consultation.observations}" /></p>
                        <c:if test="${not empty consultation.diagnostic}">
                            <p><strong>Diagnostic :</strong><br><c:out value="${consultation.diagnostic}" /></p>
                        </c:if>
                        <c:if test="${not empty consultation.traitement}">
                            <p><strong>Traitement :</strong><br><c:out value="${consultation.traitement}" /></p>
                        </c:if>
                    </section>

                    <section class="panel" aria-labelledby="titre-vitaux" style="margin-bottom: 20px;">
                        <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-pulse"/></svg> Signes vitaux du jour</p>
                        <h2 id="titre-vitaux">Mesures de l&rsquo;infirmier</h2>
                        <div class="table-wrap">
                            <table class="infirmier-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Tension</th>
                                        <th scope="col">Cœur (bpm)</th>
                                        <th scope="col">Temp. (°C)</th>
                                        <th scope="col">Resp.</th>
                                        <th scope="col">Poids (kg)</th>
                                        <th scope="col">Taille (cm)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty signesVitaux}">
                                            <c:forEach var="sv" items="${signesVitaux}" end="0">
                                                <tr>
                                                    <td><c:out value="${sv.tensionArterielle}" /></td>
                                                    <td><c:out value="${sv.frequenceCardiaque}" /></td>
                                                    <td><c:out value="${sv.temperature}" /></td>
                                                    <td><c:out value="${sv.frequenceRespiratoire}" /></td>
                                                    <td><c:out value="${sv.poids}" /></td>
                                                    <td><c:out value="${sv.taille}" /></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="6" class="empty-state">Aucun signe vital enregistré.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <c:if test="${consultation.statut.name() == 'EN_COURS'}">
                        <section class="panel" aria-labelledby="titre-cloture" style="margin-bottom: 20px;">
                            <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg> Scénario A — Prise en charge directe</p>
                            <h2 id="titre-cloture">Diagnostic et clôture</h2>
                            <p>Si la situation est gérable (pathologie courante, prescription simple), établissez le diagnostic, prescrivez le traitement puis clôturez.</p>
                            <form class="auth-form" method="post" action="${pageContext.request.contextPath}/generaliste/consultation" accept-charset="UTF-8">
                                <input type="hidden" name="action" value="cloturer">
                                <input type="hidden" name="id" value="${consultation.id}">
                                <div class="form-grid">
                                    <div class="field field-full">
                                        <label class="field-label" for="diagnostic">Diagnostic</label>
                                        <textarea class="field-input" id="diagnostic" name="diagnostic" required></textarea>
                                    </div>
                                    <div class="field field-full">
                                        <label class="field-label" for="traitement">Traitement prescrit</label>
                                        <textarea class="field-input" id="traitement" name="traitement" placeholder="Ex. Paracétamol 1g, 3 fois/jour" required></textarea>
                                    </div>
                                    <div class="form-actions">
                                        <button class="submit-button" type="submit"><span>Clôturer</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                                    </div>
                                </div>
                            </form>
                        </section>

                        <section class="panel" aria-labelledby="titre-avis">
                            <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-diagonal"/></svg> Scénario B — Télé-expertise</p>
                            <h2 id="titre-avis">Demander un avis spécialiste</h2>
                            <p>La consultation restera ouverte avec le statut EN_ATTENTE_AVIS_SPECIALISTE jusqu&rsquo;à réception de l&rsquo;avis.</p>

                            <form class="search-form" method="get" action="${pageContext.request.contextPath}/generaliste/consultation" accept-charset="UTF-8" style="margin-bottom: 20px;">
                                <input type="hidden" name="id" value="${consultation.id}">
                                <div class="field">
                                    <label class="field-label" for="specialite">1. Spécialité requise</label>
                                    <select class="field-input" id="specialite" name="specialite" required>
                                        <option value="">— Choisir —</option>
                                        <c:forEach var="s" items="${specialites}">
                                            <option value="${s}" ${s == specialiteChoisie ? 'selected' : ''}><c:out value="${s}" /></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button class="submit-button" type="submit"><span>Rechercher</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                            </form>

                            <c:if test="${not empty specialistes}">
                                <p class="form-section-title" style="margin-bottom: 12px;">2. Spécialistes — triés par tarif croissant</p>
                                <div class="table-wrap" style="margin-bottom: 20px;">
                                    <table class="infirmier-table">
                                        <thead>
                                            <tr>
                                                <th scope="col">Nom</th>
                                                <th scope="col">Tarif</th>
                                                <th scope="col">Choix</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sp" items="${specialistes}">
                                                <tr>
                                                    <td class="patient-cell"><strong>Dr <c:out value="${sp.prenom}" /> <c:out value="${sp.nom}" /></strong><span><c:out value="${sp.specialite}" /></span></td>
                                                    <td><c:out value="${sp.tarif}" /> DH</td>
                                                    <td><a class="btn-link" href="${pageContext.request.contextPath}/generaliste/consultation?id=${consultation.id}&amp;specialite=${specialiteChoisie}&amp;specialisteId=${sp.id}">Choisir</a></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>

                            <c:if test="${not empty specialisteChoisi}">
                                <p class="form-section-title" style="margin-bottom: 12px;">3. Créneaux de Dr <c:out value="${specialisteChoisi.prenom}" /> <c:out value="${specialisteChoisi.nom}" /></p>
                                <form class="auth-form" method="post" action="${pageContext.request.contextPath}/generaliste/consultation" accept-charset="UTF-8">
                                    <input type="hidden" name="action" value="demande">
                                    <input type="hidden" name="id" value="${consultation.id}">
                                    <input type="hidden" name="specialisteId" value="${specialisteChoisi.id}">
                                    <div class="table-wrap" style="margin-bottom: 20px;">
                                        <table class="infirmier-table">
                                            <thead>
                                                <tr>
                                                    <th scope="col">4. Créneau disponible (futur)</th>
                                                    <th scope="col">Début</th>
                                                    <th scope="col">Fin</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty creneauxDisponibles}">
                                                        <c:forEach var="cr" items="${creneauxDisponibles}">
                                                            <tr>
                                                                <td><input type="radio" name="creneauId" value="${cr.id}" required></td>
                                                                <td><c:out value="${cr.debut}" /></td>
                                                                <td><c:out value="${cr.fin}" /></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr><td colspan="3" class="empty-state">Aucun créneau disponible.</td></tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                    <c:if test="${not empty autresCreneaux}">
                                        <div class="table-wrap" style="margin-bottom: 20px;">
                                            <table class="infirmier-table">
                                                <thead>
                                                    <tr>
                                                        <th scope="col">Créneau réservé ou passé</th>
                                                        <th scope="col">Statut</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="cr" items="${autresCreneaux}">
                                                        <tr>
                                                            <td><c:out value="${cr.debut}" /> — <c:out value="${cr.fin}" /></td>
                                                            <td><span class="status-pill"><c:out value="${cr.statut}" /></span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <div class="form-grid">
                                        <p class="form-section-title">5. Demande d&rsquo;expertise</p>
                                        <div class="field field-full">
                                            <label class="field-label" for="question">Question posée au spécialiste</label>
                                            <textarea class="field-input" id="question" name="question" required></textarea>
                                        </div>
                                        <div class="field">
                                            <label class="field-label" for="priorite">Niveau de priorité</label>
                                            <select class="field-input" id="priorite" name="priorite" required>
                                                <option value="URGENTE">URGENTE</option>
                                                <option value="NORMALE" selected>NORMALE</option>
                                                <option value="NON_URGENTE">NON URGENTE</option>
                                            </select>
                                        </div>
                                        <div class="form-actions">
                                            <button class="submit-button" type="submit"><span>Envoyer la demande</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                                        </div>
                                    </div>
                                </form>
                            </c:if>
                        </section>
                    </c:if>

                    <c:if test="${consultation.statut.name() == 'EN_ATTENTE_AVIS_SPECIALISTE'}">
                        <section class="panel" aria-labelledby="titre-demandes">
                            <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-diagonal"/></svg> Télé-expertise en cours</p>
                            <h2 id="titre-demandes">Demandes d&rsquo;avis liées</h2>
                            <p>La consultation reste ouverte en attente de l&rsquo;avis du spécialiste.</p>
                            <div class="table-wrap">
                                <table class="infirmier-table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Spécialiste</th>
                                            <th scope="col">Question</th>
                                            <th scope="col">Priorité</th>
                                            <th scope="col">Créneau</th>
                                            <th scope="col">Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty demandes}">
                                                <c:forEach var="d" items="${demandes}">
                                                    <tr>
                                                        <td class="patient-cell"><strong>Dr <c:out value="${d.specialiste.prenom}" /> <c:out value="${d.specialiste.nom}" /></strong><span><c:out value="${d.specialiste.specialite}" /></span></td>
                                                        <td><c:out value="${d.question}" /></td>
                                                        <td><c:out value="${d.priorite}" /></td>
                                                        <td><c:out value="${d.creneau.debut}" /></td>
                                                        <td><span class="status-pill"><c:out value="${d.statut}" /></span></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr><td colspan="5" class="empty-state">Aucune demande liée.</td></tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
